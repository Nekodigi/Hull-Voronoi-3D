public float[] linspace(float start, float end, int count){
  float[] result = new float[count];
  for(int i = 0; i < count; i++){
    float val = map(i, 0, count-1, start, end);
    result[i] = val;
  }
  return result;
}

public float[] range(int end){
  float[] result = new float[end];
  for(int i = 0; i < end; i++){
    result[i] = i;
  }
  return result;
}

public int searchsorted(float[] target, float value){
  for(int i = 1; i < target.length; i++){
    if(target[i-1] < value && value <= target[i]){
      return i;
    }
  }
  if(value == target[0]){
    return 0;
  }
  print(value);
  throw new IllegalStateException();
}

public float[][] transpose(float[][] target){
  float[][] result = new float[target[0].length][target.length];
  for (int i = 0; i < target.length; i++) {
    for (int j = 0; j < target[i].length; j++) {
      result[j][i] = target[i][j];
    }
  }
  return result;
}

public float[][] dot(float[][] A, float[][] B){
  float[][] result = new float[A.length][B[0].length];
  for(int j = 0; j < A.length; j++){
    for(int i = 0; i < B[0].length; i++){
      for(int m = 0; m < A[0].length; m++){
        result[j][i] += A[j][m]*B[m][i];
      }
    }
  }
  return result;
}

public float[] dot(float[][] A, float[] B){
  float[] result = new float[A.length];
  for(int i = 0; i < A.length; i++){
    for(int m = 0; m < A[0].length; m++){
      result[i] += A[i][m]*B[m];
    }
  }
  return result;
}
