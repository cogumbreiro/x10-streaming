public SharedClock(clock:Clock) {
    private var participants = 1;
    private var advances = 0;
    
    public def register() {
        participants += 1;
        return this;
    }
    
    public def advance() {
        if (advances > participants) throw new IllegalStateException();
        advances += 1;
        if (advances == participants) {
            clock.advance();
            advances = 0;
        }
    }
}
