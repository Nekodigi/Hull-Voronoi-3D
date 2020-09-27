int binomial(int n, int k){
  if(k > n-k){
    k = n-k;//speed up
  }
  int b = 1;
  for(int i = 1; i <= k; i++){
    b *= (n+1-i)/i;
  }
  return b;
}
