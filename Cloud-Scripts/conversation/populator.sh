#!/bin/bash
conversationFolder=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`/conversation
python conversationFolder/postConversation.py
