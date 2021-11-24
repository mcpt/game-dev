/** Currency system for tower defense
 *  - Rewards player for popping balloon
 *  - Keeps track of balance
 *  - Checks for sufficient funds when purchasing tower
 */

// Current amount of money owned by the player
int currentBalance = 500; // Give the user $500 of starting balance
final int rewardPerBalloon = 20; // Money earned by popping a balloon
final int towerPrice = 100; // Price to purchase a single tower

void handleBalloonPop() {
  // Reward the player for popping the balloon
  increaseBalance(rewardPerBalloon);
}


void increaseBalance(int amount) {
  currentBalance += amount; // Increase the current balance by the amount given
}


/** Checks to see if there is sufficient balance for purchasing a certain item
 *  Parameter "cost" is the cost of the tower to be purchased
 */
boolean hasSufficientFunds(int cost) {
  if (currentBalance < cost) {
    return false; // Not enough money to purchase the tower
  }
  else {
    return true; // Enough money to purchase the tower
  }
}

/** Purchases a tower
 *  Parameter "cost" is the cost of the tower to be purchased
 */
void purchaseTower(int cost) {
  currentBalance -= cost;
}

// Checks to see if the user is attempting to purchase/pick up a tower but has insufficient funds
boolean attemptingToPurchaseTowerWithoutFunds() {
  if ((mousePressed && withinBounds()) && !hasSufficientFunds(towerPrice)) {
    return true;
  }
  else {
    return false;
  }
}

// Displays the user's current balance on the screen
void drawBalanceDisplay() {
  // If the user is attempting to purchase a tower without funds, warn them with red display text
  if (attemptingToPurchaseTowerWithoutFunds()) {
    fill(towerErrorColour); // Red text
  }
  else {
    fill(0); // Black text
  }
  
  text("Current Balance: $" + currentBalance, 336, 65);
}
