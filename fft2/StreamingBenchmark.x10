import x10.util.Pair;

public struct StreamingBenchmark(readerCount:Int, iterCount:Int) {
    public static type IntWriter = StreamWriter[Int];
    public static type IntReader = StreamReader[Int];
    public static type Broadcast[T] = Stream.Broadcast[T];
    
    static struct Driver(readerCount:Int, iterCount:Int) {
        private val writers:Rail[IntWriter];
        private val readers:Rail[() => void];
        
        
        public def this(clocks:Rail[Clock], readerCount:Int, iterCount:Int) {
            property(readerCount, iterCount);
            val broadcasts = new Rail[Broadcast[Int]](clocks.size,
                (x:Int) => Stream.makeBroadcast[Int](readerCount, clocks(x), 1));
            this.writers = new Rail[IntWriter](broadcasts.size,
                (x:Int) => broadcasts(x).first);
            // construct the readers as functions
            this.readers = new Rail[() => void](readerCount,
                (readerIdx:Int) =>
                    () => {
                        val streams = new Rail[IntReader](clocks.size,
                            (clockIdx:Int) => broadcasts(clockIdx).second(readerIdx));
                        try {
                            while (true) {
                                var result:Int = 0;
                                for (stream in streams.values()) {
                                    result += stream();
                                }
                                //Console.OUT.println(result);
                            }
                        } catch (EOSException) {/* read all the elements */}
                    });
        }
        
        public def runWriter() {
            //Console.OUT.println(iterCount);
            for (p in 1..iterCount) {
                for (writer in writers.values()) {
                    writer() = p;
                    //Console.OUT.println(p);
                }
            }
            for (writer in writers.values()) {
                writer.close();
            }
        }
        
        public def readers() {
            return readers.values();
        }
    } 
    
    public def run2Clocks() {
        finish async {
            val c1 = Clock.make("clock1");
            val c2 = Clock.make("clock2");
            val app = new Driver([c1 as Clock, c2], readerCount, iterCount);
            
            async clocked(c1, c2)
                app.runWriter();
                
            for (reader in app.readers()) {
                async clocked(c1, c2) {
                    reader();
                }
            }
        }
    }    
    
    public def run4Clocks() {
        finish async {
            val c1 = Clock.make("clock1");
            val c2 = Clock.make("clock2");
            val c3 = Clock.make("clock3");
            val c4 = Clock.make("clock4");
            val app = new Driver([c1 as Clock, c2, c3, c4], readerCount, iterCount);
            
            async clocked(c1, c2, c3, c4)
                app.runWriter();
                
            for (reader in app.readers()) {
                async clocked(c1, c2, c3, c4) {
                    reader();
                }
            }
        }
    }

    public def run8Clocks() {
        finish async {
            val c1 = Clock.make("clock1");
            val c2 = Clock.make("clock2");
            val c3 = Clock.make("clock3");
            val c4 = Clock.make("clock4");
            val c5 = Clock.make("clock1");
            val c6 = Clock.make("clock2");
            val c7 = Clock.make("clock3");
            val c8 = Clock.make("clock4");
            val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8], readerCount, iterCount);
            
            async clocked(c1, c2, c3, c4, c5, c6, c7, c8)
                app.runWriter();
                
            for (reader in app.readers()) {
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8) {
                    reader();
                }
            }
        }
    }    
    
    public def run16Clocks() {
        finish async {
            val c1 = Clock.make("clock1");
            val c2 = Clock.make("clock2");
            val c3 = Clock.make("clock3");
            val c4 = Clock.make("clock4");
            val c5 = Clock.make("clock5");
            val c6 = Clock.make("clock6");
            val c7 = Clock.make("clock7");
            val c8 = Clock.make("clock8");
            val c21 = Clock.make("clock21");
            val c22 = Clock.make("clock22");
            val c23 = Clock.make("clock23");
            val c24 = Clock.make("clock24");
            val c25 = Clock.make("clock25");
            val c26 = Clock.make("clock26");
            val c27 = Clock.make("clock27");
            val c28 = Clock.make("clock28");
            val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c21, c22, c23, c24, c25, c26, c27, c28], readerCount, iterCount);
            
            async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c21, c22, c23, c24, c25, c26, c27, c28)
                app.runWriter();
                
            for (reader in app.readers()) {
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c21, c22, c23, c24, c25, c26, c27, c28) {
                    reader();
                }
            }
        }
    }
    
    public def run(id:Int) {
        if(id == 0) run2Clocks();
        else if(id == 1) run4Clocks();
        else if(id == 2) run8Clocks();
        else if(id == 3) run16Clocks();
        else throw new IllegalArgumentException("Unknown id=" + id);
    }
    
    public def cleanup() {
        System.gc();
        System.sleep(1 * 1000); // wait for GC to terminate
    }
    
    public def warmup() {
        val intensity = 300000000;
        val calculatePiFor = (start:Int, nrOfElements:Int) => {
            var acc:Double = 0.0;
            for (i in start..(start + nrOfElements)) {
                acc += 4.0 * (1 - (i % 2) * 2) / (2 * i + 1);
            }
            return acc;
        };
        calculatePiFor(0, intensity);
    }

    
    public static def main(args:Array[String](1)):void {
        val participants = args.size > 0 ? Int.parse(args(0)) : 2; // 1 reader, 1 writer
        assert participants >= 2 : "We need at least 2 participants.";
        val clockId = args.size > 1 ? Int.parse(args(1)) : 0; // 2 clocks
        assert clockId >= 0 && clockId <= 3 : "The clock ID can be: 0 => 2 clocks, 1 => 4 clocks, 2 => 8 clocks, 3 => 16 clocks.";
        val iterations = args.size > 2 ? Int.parse(args(2)) : 10000; // these much iterations
        assert iterations > 0: "The number of iterations must be a postive number.";
        val benchmark = new StreamingBenchmark(participants - 1, iterations);
        val start = System.currentTimeMillis();
        benchmark.warmup();
        benchmark.cleanup();
        benchmark.run(clockId);
        val end = System.currentTimeMillis();
        Console.OUT.println((end - start));
    }
}
