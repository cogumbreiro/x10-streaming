/*
float->float filter FloatDuplicate
{
    work push 1 pop 1 {
    
        push(pop() * 2);
    }
}
*/

public class FloatDuplicate extends Filter[Float,Float]
{
    public def work() {
        push(pop() * 2);
    }
}











