using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace _3315
{
    class Program
    {
        static void Main(string[] args)
        {
            var j = new ParadoxJudgement();

            //入力読み込み
            j.ReadInput();
            //真偽値計算
            j.Resolve();
            //結果出力
            Console.WriteLine(j.result);
            //待ち
            Console.ReadLine();
        }
    }

    class ParadoxJudgement
    {
        private Dictionary<int, bool> inputDic;
        private string pat = @"\s*(\d+)\s*is\s*(\w+)";

        public int result = -1;//0 or -1

        public ParadoxJudgement()
        {
            inputDic = new Dictionary<int, bool>();
        }

        public void ReadInput()
        {
            Regex r = new Regex(pat, RegexOptions.IgnoreCase);

            string line;
            while ((line = Console.ReadLine()) != null)
            {
                try
                {
                    var matcher = r.Match(line);
                    var num = int.Parse(matcher.Groups[1].ToString());
                    var tf = "true".Equals(matcher.Groups[2].ToString(), StringComparison.OrdinalIgnoreCase);

                    inputDic.Add(num, tf);
                }
                catch (Exception _)
                {
                    break;
                }
            }
        }

        public void Resolve()
        {
            var cnt = inputDic.Count;
            var max = (int)Math.Pow(2, cnt);

            for (var tfTable = 0; tfTable < max; tfTable++)
            {
                var compFlg = true;
                var idx = 1;
                foreach (var cond in inputDic)
                {
                    //言ってることの真偽
                    var tfClaim = IsTrue(tfTable, cond.Key);
                    //その人の真偽
                    var tfPerson = IsTrue(tfTable, idx++);
                    if (
                        //言ってることが正しくて、その人が偽
                        tfClaim.Equals(cond.Value) && !tfPerson
                        //言ってることが間違っていて、その人が真
                        || !tfClaim.Equals(cond.Value) && tfPerson
                    )
                    {
                        compFlg = false;
                        break;
                    }
                }
                if (compFlg)
                {
                    result = 0;
                    break;
                }
            }
        }
        /// <summary>
        /// 右（低位）から数えたビット番号
        /// 一番右（1の位）が1
        /// </summary>
        /// <param name="target"></param>
        /// <param name="bitNo"></param>
        /// <returns></returns>
        private bool IsTrue(int target, int bitNo)
        {
            return ((target >> --bitNo)&1) == 1;
        }
    }
}
