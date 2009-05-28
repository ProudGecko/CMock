
typedef unsigned short U16;

typedef struct _POINT_T
{
  int x;
  int y;
} POINT_T;

// typedef edge case
typedef void VOID_TYPE_CRAZINESS;

struct _DUMMY_T { unsigned int a; float b; };


/* fun parsing & mock generation cases */

void var_args1(int a, ...);
void var_args2(int a, int b, ...);

VOID_TYPE_CRAZINESS void_type_craziness1(int, float, double, char, short, long, long int, long long, void*);
int void_type_craziness2( VOID_TYPE_CRAZINESS );

   void  crazy_whitespace  (   int    lint, double shot  ,  short  stack )  ;

char
 crazy_multiline
(
  int a,
  unsigned int b);

U16  *ptr_return1(int a);
U16*  ptr_return2(int a);
U16 * ptr_return3(int a);

unsigned int** ptr_ptr_return1(unsigned int** a);
unsigned int* *ptr_ptr_return2(unsigned int* *a);
unsigned int **ptr_ptr_return3(unsigned int **a);
unsigned int ** ptr_ptr_return4(unsigned int ** a);

extern unsigned long int incredible_descriptors(register const unsigned short a);

void const_variants1( const char* a, int const, unsigned short const * c );

// crazy const magic fairy dust
void const_variants2( 
	struct _DUMMY_T const * const param1,
	const unsigned long int const * const param2,
	const struct _DUMMY_T const * param3 ); 
