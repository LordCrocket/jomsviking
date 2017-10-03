int asm_main( void ) __attribute__((sysv_abi));

int main()
{
  int ret_status;
  ret_status = asm_main();
  return ret_status;
}
