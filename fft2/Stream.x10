public struct Stream[T](clock:Clock, reader:Stream.Reader[T], writer:Stream.Writer[T]) {
    public static class EOSException extends Error {}
    private val buffer:DoubleBuffer[Maybe[T]];
    public def this(clock:Clock) {T haszero} {
        this(clock, Zero.get[T]());
    }
    
    public def this(clock:Clock, zero:T) {
        val nothing = Maybe.makeNothing[T](zero);
        val rail = new Rail[Maybe[T]](2, nothing);
        val buffer = new DoubleBuffer[Maybe[T]](clock, rail);
        val reader = new Reader[T](clock, buffer.reader);
        val writer = new Writer[T](clock, buffer.writer, Maybe.Factory.make[T](zero));
        property(clock, reader, writer);
        this.buffer = buffer;
    }
    public static struct Writer[T](clock:Clock) {
        private val buffer:DoubleBuffer.Writer[Maybe[T]];
        private val factory:Maybe.Factory[T];
        private def this(clock:Clock, buffer:DoubleBuffer.Writer[Maybe[T]], factory:Maybe.Factory[T]) {
            property(clock);
            this.buffer = buffer;
            this.factory = factory;
        }

        public operator this()=(value:T) {
            buffer() = Maybe.make[T](value);
        }
        
        public def set(value:Maybe[T]):void {
            buffer() = value;
        }

        public def close():void {
            buffer() = factory.makeNothing();
        }
    }
    public static struct Reader[T](clock:Clock) implements ()=>T {
        private val buffer:DoubleBuffer.Reader[Maybe[T]];
        
        private def this(clock:Clock, buffer:DoubleBuffer.Reader[Maybe[T]]) {
            property(clock);
            this.buffer = buffer;
        }
        
        public def get() throws EOSException:T {
            val datum = buffer.get();
            if (datum.isNothing()) {
                throw new EOSException();
            }
            return datum.value;
        }
        
        public def getMaybe() {
            return buffer.get();
        }
        
        public operator this():T {
            return get();
        }
    }
}
