final int TOTAL_WAVES = 20;
int currentWave = 0;
ArrayList<float[]>[] waves = new ArrayList[TOTAL_WAVES];

void createWaves() {
  int baseDelay = 100; // All waves start with a 100 frame delay;
  for (int wave = 0; wave < 20; wave++) {
    waves[wave] = new ArrayList<float[]>();
    int balloonCount = wave * wave + 5;
    int balloonHP = 20 + wave * wave * 2;
    float balloonSpeed = 2 + wave * 0.25;
    float balloonSpacing = 22 - wave;
    for (int i = 0; i < balloonCount; i++) {
      waves[wave].add(new float[]{0, baseDelay + i * balloonSpacing, balloonSpeed, balloonHP, balloonHP, 0, i});
    }
  }
}

void nextWave() {
  // Killed all balloons in first wave and there are remaining waves
  if (balloons.isEmpty() && currentWave < TOTAL_WAVES) {
    handleWaveReward(currentWave);
    for (int i = 0; i < waves[currentWave].size(); i++) {
      balloons.add(waves[currentWave].get(i));
    }
    currentWave++;
  }
}

//method to give user money for completing a wave
void handleWaveReward(int waveNum) {
   increaseBalance(baseRewardPerWave * waveNum);
}
