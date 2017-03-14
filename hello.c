#include <stdio.h>
#include <unistd.h>

int main()
{
  int x=0;
  while(1)
  {
    printf("Pid %d: %d\n", getpid(), x++);
    sleep(1);
  }
  return 0;
}