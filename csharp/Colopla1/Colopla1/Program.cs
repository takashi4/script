using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colopla1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.ReadLine();
            var numbers = Console.ReadLine().Split(',').Select(num => int.Parse(num)).ToList<int>();

            var obj = new Solver(numbers);
            Console.WriteLine(obj.GetMaxCombo().Count);

            Console.ReadLine();
        }
    }

    class Solver
    {
        private List<int> lis;
        public Solver(List<int> lis)
        {
            this.lis = lis;
        }

        public List<int> GetMaxCombo()
        {
            var ret = new List<int>();
            if (lis.Count == 0) return null;
            for (int i=0,l=lis.Count; i<l; i++)
            {
                var _ret = new List<int>();
                int start = lis.ElementAt(i);
                var cdr = lis.Skip(1);
                if (cdr.Count() == 0) break;

                if (cdr.Count() > 0 && start < cdr.ElementAt(0)) 
            }
            return (List<int>) _getMaxCombo(lis.ElementAt(0), lis.Skip(1));
        }

        private IEnumerable<int> _getMaxCombo(int i, IEnumerable<int> li)
        {
            switch (li.Count())
            {
                case 0:
                    return new List<int>() { i };
                case 1:
                    return li;
                case 2:
                    if (li.ElementAt(0) < li.ElementAt(1)) return li;
                    else return new List<int>() { li.ElementAt(0) };
                    break;
                case 3:


            }

            foreach (var i in lis)
            {
            }
            return new List<int>();
        }
    }
}
