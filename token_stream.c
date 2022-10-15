#include "token_stream.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void Token_Stream_Init(Token_Stream* token_stream){
	token_stream->head = token_stream->end = NULL;
	token_stream->num = 0;
}

int append_Token(Token_Stream* token_stream, char* text, int token, int lines, int pos_start, int pos_end){
	// 定义一个新的Token
	Token_Node* new_Token = (Token_Node*) malloc (sizeof(Token_Node));
	if(new_Token == NULL)
		return BAD_MALLOC;
	strcpy(new_Token->text, text);
	new_Token->token = token;
	new_Token->lines = lines;
	new_Token->pos_start = pos_start;
	new_Token->pos_end = pos_end;
	new_Token->next = NULL;
	// 将Token插入链表
	if(token_stream->head == NULL && token_stream->end == NULL){
		token_stream->head = token_stream->end = new_Token;
		token_stream->num++;
		return APPEND_SUCCEED;
	}
	else if(token_stream->head != NULL && token_stream->end != NULL){
		token_stream->end->next = new_Token;
		token_stream->end = new_Token;
		token_stream->num++;
		return APPEND_SUCCEED;
	}
	else
		return BAD_LIST;
} 

void traversal_Token_Stream(const Token_Stream* token_stream){
	if(token_stream){
		for(Token_Node * Token = token_stream->head; Token != NULL; Token = Token->next){
			printf("%s\t%d\t%d\t%d\t%d\n",
					Token->text,
					Token->token,
					Token->lines,
					Token->pos_start,
					Token->pos_end
				);
		}
	}
}