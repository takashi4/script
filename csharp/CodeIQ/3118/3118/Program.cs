using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3118
{
    class Program
    {
        static void Main(string[] args)
        {
            var mat = new Matrix();

            //入力の読み込み
            mat.ReadInput();
            //全経路の計算
            mat.CalcRoute();
            //結果の出力
            Console.WriteLine(mat.MinRoute);
            //入力待ち
            //Console.ReadLine();
        }
    }

    class Matrix
    {
        private List<List<int>> m = new List<List<int>>();
        private int N;
        private int[,] _m;

        public int MaxRoute { get; set; }
        public int MinRoute { get; set; }

        public void ReadInput()
        {
            string line;
            while ((line = Console.ReadLine()) != null)
            {
                try
                {
                    var row = line.ToCharArray().Select(i => int.Parse(i.ToString())).ToList();
                    m.Add(row);
                }
                catch(Exception _)
                {
                    break;
                }
            }
            N = m.Count;
        }

        public void CalcRoute()
        {
            _m = new int[N,N];

            MinRoute = Route(0, 0);
        }

        private int Route(int x, int y)
        {
            return (_m[x, y] > 0)          ? _m[x, y]
                 : x + 1 < N && y + 1 < N  ? (_m[x, y] = Min(Route(x + 1, y), Route(x, y + 1)) + m[x][y])
                 : x + 1 == N && y + 1 < N ? (_m[x, y] = Route(x, y + 1) + m[x][y])
                 : y + 1 == N && x + 1 < N ? (_m[x, y] = Route(x + 1, y) + m[x][y])
                                           : (_m[x, y] = m[N - 1][N - 1])
                 ;
        }

        private int Min(int r1, int r2)
        {
            return r1 < r2 ? r1 : r2;
        }
    }
}
