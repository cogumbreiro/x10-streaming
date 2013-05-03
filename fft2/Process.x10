class Process {
    def bind(source:Source[T], sink:Sink[T]) {
        sink.inStream = source.createInStream(sink.inSize);
        async clocked(source.clock) {
            while(source.isAlive) {
                source.work();
            }
        }
        async clocked(source.clock) {
            while(sink.isAlive) {
                sink.work();
            }
        }
    }
}
