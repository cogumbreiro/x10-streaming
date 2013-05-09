public struct Maybe[T] {
    public val value:T;
    private val isNothing:Boolean;
    private def this(value:T, isNothing:Boolean) {
        this.value = value;
        this.isNothing = isNothing;
    }
    public def isJust() = ! isNothing;
    public def isNothing() = isNothing;
    public static def make[T](value:T) = new Maybe[T](value, false);
    public static def makeNothing[T](value:T) = new Maybe[T](value, true);
    public static def makeNothing[T]() {T haszero} = makeNothing[T](Zero.get[T]());
    public static struct Factory[T] {
        private val zero:T;
        public def this(zero:T) {
            this.zero = zero;
        }
        public def this() {T haszero} {
            this.zero = Zero.get[T]();
        }
        public def makeJust(value:T) {
            return value as Maybe[T];
        }
        public def makeNothing() {
            return Maybe.makeNothing[T](zero);
        }
        public static make[T](zero:T) = new Factory[T](zero);
    }
    public static def main(args:Rail[String]):void {
        Console.OUT.println(Maybe.make[Float](0.0f));
    }
}

