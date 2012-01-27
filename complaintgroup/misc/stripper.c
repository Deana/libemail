#include <string.h>
#include <stdlib.h>
#include <stdio.h>

char * stripper_dup( const char * str ){
	char * ptr = strdup( str );
	char * inptr = (char * )str;
	int intag = 0;
	char buffer;
	char *p = ptr;

	memset( ptr, 0, strlen(str) + 1 );

	while( ( buffer = *inptr++ ) != '\0' ){
		if( buffer == '<' ){
			intag++;
			continue;
		}	

		if( buffer == '>' ){
			intag--;
			continue;
		}

		if( intag < 1 )
			*(ptr++) = buffer;
	}
	return p;
}

char * stripper( char * str ){
	char * results = stripper_dup( str );
	strcpy( str, results );
	free( results );
	return str;
}

int main(void){

	char input[] = "this is some <a href=\"foo\">links</a> and stuff <br/>. <h1>Hello</h1> world";

	printf ("input:  [%s]\n", input );
	printf ("output: [%s]\n", stripper( input ) );

	return 0;

}
