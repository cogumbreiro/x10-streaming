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
    
    static val runs = [
        (readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val app = new Driver([c1 as Clock], readerCount, iterCount);
                
                async clocked(c1)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1) {
                        reader();
                    }
                }
            }
        }
        
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
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
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3], readerCount, iterCount);
                
                async clocked(c1, c2, c3)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3) {
                        reader();
                    }
                }
            }
        }    
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
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
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
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
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val c10 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9, c10], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val c10 = Clock.make();
                val c11 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val c10 = Clock.make();
                val c11 = Clock.make();
                val c12 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val c10 = Clock.make();
                val c11 = Clock.make();
                val c12 = Clock.make();
                val c13 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val c10 = Clock.make();
                val c11 = Clock.make();
                val c12 = Clock.make();
                val c13 = Clock.make();
                val c14 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val c10 = Clock.make();
                val c11 = Clock.make();
                val c12 = Clock.make();
                val c13 = Clock.make();
                val c14 = Clock.make();
                val c15 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15) {
                        reader();
                    }
                }
            }
        }
        ,(readerCount:Int, iterCount:Int) => {
            finish async {
                val c1 = Clock.make();
                val c2 = Clock.make();
                val c3 = Clock.make();
                val c4 = Clock.make();
                val c5 = Clock.make();
                val c6 = Clock.make();
                val c7 = Clock.make();
                val c8 = Clock.make();
                val c9 = Clock.make();
                val c10 = Clock.make();
                val c11 = Clock.make();
                val c12 = Clock.make();
                val c13 = Clock.make();
                val c14 = Clock.make();
                val c15 = Clock.make();
                val c16 = Clock.make();
                val app = new Driver([c1 as Clock, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16], readerCount, iterCount);
                
                async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16)
                    app.runWriter();
                    
                for (reader in app.readers()) {
                    async clocked(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16) {
                        reader();
                    }
                }
            }
        }
    ];

    public def run(clockCount:Int) {
        assert clockCount >= 1 && clockCount <= StreamingBenchmark.runs.size;
        StreamingBenchmark.runs(clockCount - 1)(readerCount, iterCount);
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
        val clocks = args.size > 1 ? Int.parse(args(1)) : 0; // 2 clocks
        assert clocks >= 1 && clocks <= StreamingBenchmark.runs.size : "Supply 1 up to 16 clocks.";
        val iterations = args.size > 2 ? Int.parse(args(2)) : 10000; // these much iterations
        assert iterations > 0: "The number of iterations must be a postive number.";
        val benchmark = new StreamingBenchmark(participants - 1, iterations);
        val start = System.currentTimeMillis();
        benchmark.warmup();
        benchmark.cleanup();
        benchmark.run(clocks);
        val end = System.currentTimeMillis();
        Console.OUT.println((end - start));
    }
}
