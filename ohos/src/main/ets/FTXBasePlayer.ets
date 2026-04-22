let playerIdCounter = 0;

export class FTXBasePlayer {
  protected playerId: number;

  constructor() {
    this.playerId = ++playerIdCounter;
  }

  getPlayerId(): number {
    return this.playerId;
  }

  destroy(): void {
  }
}
