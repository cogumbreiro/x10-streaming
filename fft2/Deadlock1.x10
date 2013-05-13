public class Deadlock1 {
    public static def main(Array[String](1)):void {
        finish {
        val clock = Clock.make();
            async clocked(clock) {Console.OUT.println(1);finish{clock.advance();}}
        }
    }
}
