using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;

namespace Colopla1
{
    public class Program
    {
        static void Main(string[] args)
        {
            var sw = new Stopwatch();
            string line;
            var str = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 49";
            //var str = "1 2 3 5 4 4 3 3 5";
            for (; (line = Console.ReadLine()) != null;)
            {
                //var numbers = Console.ReadLine().Split(' ').Select(num => int.Parse(num)).ToList<int>();
                var numbers = str.Split(' ').Select(num => int.Parse(num)).ToList();
                //var numbers = line.Split(' ').Select(num => int.Parse(num)).ToList();

                sw.Reset();
                sw.Start();
                var result = new Solver(numbers).GetMaxCombo();
                sw.Stop();
                Console.WriteLine(result.Count);
                Console.WriteLine(sw.Elapsed);
                Console.WriteLine(string.Join(" ", result.ToArray()));
            }
        }
    }

    public class Solver
    {
        private List<int> lis;
        public Solver(List<int> lis)
        {
            this.lis = lis;
        }
        public List<int> GetMaxCombo()
        {
            Intermediate.ClearDic();
            var ret = new List<int>();
            for (int i = 0, l = lis.Count(); i < l - 1; i++)
            {
                var tmp = new Intermediate(
                    lis.Skip(i+1).ToList(),
                    new List<int>() {  lis[i] }
                ).GetNext().resultLis;

            if (tmp.Count() > ret.Count())
                ret = tmp;
            }

            return ret;
        }

        class Intermediate
        {
            public List<int> lis;
            public List<int> resultLis;

            static Dictionary<string, List<int>> _dic = new Dictionary<string, List<int>>();

            public Intermediate(List<int> lis, List<int> resultLis)
            {
                this.lis = lis;
                this.resultLis = resultLis;
            }
            public static void ClearDic()
            {
                _dic.Clear();
            }
            public Intermediate GetNext()
            {
                if (lis.Count == 0)
                    return this;
                if (_dic.ContainsKey(GetKey()))
                    return CombineDic();

                Intermediate[] res = new Intermediate[] { null, null, null };
                for (var i = 0; i < 3; i++)
                    if (this.ok(i))
                    {
                        var nextObj = next(i);
                        res[i] = nextObj.GetNext();
                        /*var key = nextObj.GetKey();
                        if (!_dic.ContainsKey(key))
                            _dic.Add(key, res[i].lis);
                            */
                    }
                var maxObj = Intermediate.SelectBigOne(res);
                if (maxObj == null)
                {
                    var key = GetKey();
                    if (!_dic.ContainsKey(key))
                        _dic.Add(key, new List<int>());

                    return this;
                }
                else
                {
                    var key = maxObj.GetKey();
                    if (!_dic.ContainsKey(key))
                        _dic.Add(key, maxObj.lis);
                    return maxObj;
                }
            }
            public string GetKey()
            {
                return string.Format(@"{0}:{1}",
                            LastItem()
                            , string.Join(",", lis.ToArray())
                );
            }
            public Intermediate CombineDic()
            {
                return new Intermediate(
                    new List<int>(),
                    resultLis.Concat(_dic[GetKey()].Skip(1)).ToList()    
                );

            }
            public int LastItem()
            {
                return resultLis.Count == 0 ? 0 : resultLis[resultLis.Count - 1];
            }
            public List<int> NoLastItem()
            {
                return resultLis.Take(resultLis.Count-1).ToList();
            }
            public Intermediate next(int i)
            {
                return new Intermediate(
                    lis.Skip(i+1).ToList(),
                    resultLis.Concat(new List<int>() { lis[i] }).ToList()
                );
            }
            public bool ok(int i)
            {
                return lis.Count > i && LastItem() < lis[i];
            }

            public static Intermediate SelectBigOne(Intermediate[] res)
            {
                var len = new int[] { 0, 0, 0 };
                for (var i=0; i<3; i++)
                    if (res[i] != null) len[i] = res[i].resultLis.Count;
                
                if (len[0] >= len[1] && len[0] >= len[2]) return res[0];
                if (len[1] >= len[0] && len[1] >= len[2]) return res[1];
                if (len[2] >= len[0] && len[2] >= len[1]) return res[2];

                return null;
            }
            
        }
    }

    static class ListExtender
    {
        public static List<T> Clone<T>(this List<T> obj)
        {
            return new List<T>(obj.ToArray().ToList());
        }
    }
    static class StackExtender
    {
        public static Stack<T> Clone<T>(this Stack<T> obj)
        {
            return new Stack<T>(obj.ToList<T>().Reverse<T>());
        }
        public static Stack<T> Pops<T>(this Stack<T> obj, int n)
        {
            for (var i = 0; i < n; i++)
                obj.Pop();
            return obj;
        }
        public static Stack<T> Adds<T>(this Stack<T> obj, Stack<T> obj2)
        {
            var ret = obj.Clone<T>();
            foreach (var o in ret)
                ret.Push(obj2.Pop());

            return ret;
        }
    }


}
