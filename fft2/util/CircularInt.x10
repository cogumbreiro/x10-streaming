/**
 * Represents an integer that can be incremented and loops around
 * at <code>loop</code>.
 * (C) 2013 - Tiago Cogumbreiro (cogumbreiro@users.sf.net)
 * MIT License http://opensource.org/licenses/MIT
 */
public final class CircularInt(loop:Int) {
    private var idx:Int = 0;
    public def increment() {
        idx += 1;
        idx %= loop;
    }
    public def get() {
        return idx;
    }
}

