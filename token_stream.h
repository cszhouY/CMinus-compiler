#ifndef _TOKEN_LIST_H_
#define _TOKEN_LIST_H_



// 词法单元
typedef struct Token_Node{
    char text[256];
    int token;
    int lines;
    int pos_start;
    int pos_end;
    struct Token_Node* next;
} Token_Node;

// 词法单元链表
typedef struct Token_Stream{
	Token_Node* head;
	Token_Node* end;
	int num;
}Token_Stream;

void Token_Stream_Init(Token_Stream* token_stream);

#define APPEND_SUCCEED 0
#define BAD_LIST 1
#define BAD_MALLOC 2
int append_Token(Token_Stream* Token_Stream, char* text, int token, int lines, int pos_start, int pos_end);

void traversal_Token_Stream(const Token_Stream* token_stream);

#endif  /* token_list.h */