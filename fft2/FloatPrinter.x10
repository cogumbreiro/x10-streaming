/*
float->void filter FloatPrinter
{
    work push 0 pop 1 {
    
        println(pop());
    }
}
*/

public class FloatPrinter[T] extends Sink[T]
{
    def work() {
        Console.OUT.println(pop());
    }
}











