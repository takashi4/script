namespace DiffForDelivery
{
    internal class Differ
    {
        private object ouptput;
        private string source;
        private string target;

        public Differ(string source, string target, object ouptput)
        {
            this.source = source;
            this.target = target;
            this.ouptput = ouptput;
        }

        public void exec()
        {
            ;
        }
    }
}