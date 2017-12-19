#!/bin/bash
conversationFolder=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
python $conversationFolder/postConversation.py $conversationFolder
