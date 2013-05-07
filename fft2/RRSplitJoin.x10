import x10.util.HashMap;
import x10.util.ArrayList;

public class RRSplitJoin[I,O](outputSize:Int) {I haszero, O haszero} extends Filter[I,O] {
    private static final class Entry[I,O](toFilter:DoubleBuffer.Writer[I],
                                     readCount:Int,
                                     fromFilter:DoubleBuffer.Reader[O]) {}
    val entries = new ArrayList[Entry[I,O]]();
    public def this(inputCount:Int, outputSize:Int) {
        super(inputCount);
        property(outputSize);
    }
    
    public def split(filter:Filter[I,O], inputCount:Int):RRSplitJoin[I,O] {
        val toFilter = new DoubleBuffer[I]();
        val fromFilter = new DoubleBuffer[O]();
        entries.add(new Entry[I,O](toFilter.writer, inputCount, fromFilter.reader));
        filter.setOutput(fromFilter);
        filter.setReader(filter.createReader(toFilter.reader));
        async clocked(toFilter.clock, fromFilter.clock) {
            filter.launch(this);
        }
        return this;
    }
    
    public def work() {
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
