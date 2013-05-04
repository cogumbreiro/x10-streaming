interface StreamNode {
    def work():void;
    def launch(isAlive:() => Boolean):void;
}
