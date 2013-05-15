import x10.util.HashMap;
import x10.util.ArrayList;

public class RRSplitJoin[I,O](outputSize:Int) {I haszero, O haszero} extends Filter[I,O] {
    private static struct Entry[I,O](filter:Filter[I,O],
                                     toFilter:Stream.Writer[I],
                                     readCount:Int,
                                     fromFilter:Cell[Stream.Reader[O]]) {}
                                     
    val entries = new ArrayList[Entry[I,O]]();
    
    val entriesInputClock = Clock.make();

    val entriesOutputClock = Clock.make();
        
    public def this(inputCount:Int, outputSize:Int) {
        super(inputCount);
        property(outputSize);
    }
    
    public def split(filter:Filter[I,O], inputCount:Int):RRSplitJoin[I,O] {
        val toFilter = new Stream[I](in.clock);
        val fromFilter = new Stream[O](); // this is bogus, just to make the compiler happy
        val cell = new Cell[Stream.Reader[O]](toFilter.reader);
        entries.add(new Entry[I,O](filter, toFilter.writer, inputCount, cell));
        filter.setInput(toFilter.reader);
        //filter.setOutput(fromFilter);
        /*
        async clocked(toFilter.clock, fromFilter.clock) {
            filter.launch();
        }*/
        return this;
    }
    
    protected def asyncLaunch() {
        assert reader != null : "call setInput(reader) first";
        
        inputBuffer = new Rail[I](entries.size());
        outputBuffer = new Rail[O](entries.size());
        
        for (entry in entries) {
            entry.filter.asyncLaunch();
        }
        
        async clocked(bufReader.clock, output.clock, entriesInputClock, entriesOutputClock) {
            launch();
        }
    }
        
    public def work() {
        // launch children
        // run them
        for (entry in entries) {
            for (_ in 1..entry.readCount) {
                entry.toFilter() = pop();
            }
        }
        for (entry in entries) {
            for (_ in 1..outputSize) {
                push(entry.fromFilter());
            }
        }
    }
}
