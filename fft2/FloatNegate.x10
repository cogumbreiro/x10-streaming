/*
float->float filter FloatNegate
{
    work push 1 pop 1 {
    
        push(pop() * -1);
    }
}
*/

public class FloatNegate extends Filter[Float,Float]
{
    public def work() {
        push(pop() * -1);
    }
}











