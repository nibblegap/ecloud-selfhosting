#!/usr/bin/env bash

function getRandomString {
        LENGTH=$1
        CHARACTERS=$2
        cat /dev/urandom | tr -dc $CHARACTERS | fold -w $LENGTH | head -n 1
}

function replaceTokensWithRandomStrings {
        INPUT="$1"
        TOBEREPLACED=$(echo "$INPUT" | grep -o  -e '@@@generate@@@:[u|l]:[0-9]\+@' -e '@@@generate@@@:[0-9]\+@')
        LOWERCASED=$(echo "$TOBEREPLACED" | grep -o ':l')
        UPPERCASED=$(echo "$TOBEREPLACED" | grep -o ':u')
        REPLACEMENT_LENGTH=$(echo "$TOBEREPLACED" | awk -F: '{ print $NF }' | sed 's/@$//g')
        if [ ! -z "$LOWERCASED" ]
        then
            RANDOMPART=$(getRandomString $REPLACEMENT_LENGTH 'a-z0-9')
        elif [ ! -z "$UPPERCASED" ]
        then
            RANDOMPART=$(getRandomString $REPLACEMENT_LENGTH 'A-Z0-9')
        else
            RANDOMPART=$(getRandomString $REPLACEMENT_LENGTH 'a-zA-Z0-9')
        fi
        echo "$INPUT" | sed "s/$TOBEREPLACED/$RANDOMPART/g"
}

function doReplacementIfNecessary {
    VALUE="$1"
    echo "$VALUE" | grep -q "@@@generate@@@" && replaceTokensWithRandomStrings "$VALUE" || echo "$VALUE"
}

function getValidationPattern {
    INPUT="$1"
    echo "$INPUT" | sed 's/^.*||||//g' | sed 's/;;;;.*$//g'
}

function getInputDirectionMessage {
    INPUT="$1"
    echo "$INPUT" | sed 's/^.*;;;;//g'
}

function getQuestion {
    INPUT="$1"
    echo "$INPUT" | sed 's/||||.*$//g'
}

function generateEnvFile {
    QUESTFILE="$1"
    ANSWERFILE="$2"
    ENVFILE="$3"
    while read KEY VALUE; do
        PREVVALUE="$VALUE"
        VALUE=$(doReplacementIfNecessary "$VALUE")
        if [[ "$PREVVALUE" = "$VALUE" ]]
        then
            if [[ "$#" -ne 1 ]]
            then
                DEFVAL=$(echo "$PREVVALUE" | grep -q ";default$" && echo "$PREVVALUE" | sed 's/;default$//g' || echo 0)
                if [[ "$DEFVAL" = "0" ]]
                then
                    PATTERN=$(getValidationPattern "$VALUE")
                    INPUT_DIRECTION=$(getInputDirectionMessage "$VALUE")
                    QUESTION=$(getQuestion "$VALUE")
                    echo "$QUESTION"
                    if [[ "$PATTERN$INPUT_DIRECTION" = "$VALUE$VALUE" ]]
                    then
                        read INPUT < /dev/tty
                    else
                        FIRST=1
                        while [[ $(echo "$INPUT" | grep -q -P "$PATTERN" && echo ok || echo nok) = "nok" ]]; do
                            if [[ ${FIRST} != "1" ]]
                            then
                                echo "$INPUT_DIRECTION"
                            else
                                FIRST=0
                            fi
                            read INPUT < /dev/tty
                         :; done
                    fi
                    echo "$KEY=$INPUT" >> "$ENVFILE"
                else
                    echo "$KEY=$DEFVAL" >> "$ENVFILE"
                fi
             else
                VALUE=$(grep "^$KEY=" "$ANSWERFILE" | awk -F= '{ print $NF }')
                echo "$KEY=$VALUE" >> "$ENVFILE"
             fi
         else
            echo "$KEY=$VALUE" >> "$ENVFILE"
         fi
    :;done <<< "$(grep -v \# ${QUESTFILE} | sed '/^$/d'| sed 's/=/        /g')"
}
