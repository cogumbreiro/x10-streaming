/*
float->void filter FloatPrinter
{
    work push 0 pop 1 {
    
        println(pop());
    }
}
*/

public class FloatPrinter[T] extends Filter[T,Any]
{
    public def work() {
        Console.OUT.println(pop() as Any);
    }
}











