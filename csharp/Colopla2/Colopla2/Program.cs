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
            Console.ReadLine();
            var numbers = Console.ReadLine().Split(' ').Select(num => int.Parse(num)).ToList();
            Console.WriteLine(
                new Solver(numbers).GetMaxComboNum()
            );
        }
    }

    public class Solver
    {
        private List<int> lis;
        private List<Item> items = new List<Item>();
        private List<int> usedItems = new List<int>();

        public Solver(List<int> lis)
        {
            this.lis = lis;
            for (int i=0, l=lis.Count; i<l; i++)
                items.Add(new Item(i, lis[i]));

            SetBeforeAfter();
        }

        private void SetBeforeAfter()
        {
            for (int i = 0, l = items.Count; i < l; i++)
            {
                var item = items[i];
                var val = item.Val;

                //Before1
                if (i >= 1 && val > items[i - 1].Val)
                    item.Before1 = items[i - 1];
                //Before2
                if (i >= 2 && val > items[i - 2].Val)
                    item.Before2 = items[i - 2];
                //Before3
                if (i >= 3 && val > items[i - 3].Val)
                    item.Before3 = items[i - 3];
                //After1
                if (l >= i + 2 && val < items[i + 1].Val)
                    item.After1 = items[i + 1];
                //After2
                if (l >= i + 3 && val < items[i + 2].Val)
                    item.After2 = items[i + 2];
                //After3
                if (l >= i + 4 && val < items[i + 3].Val)
                    item.After3 = items[i + 3];
            }
        }

        public int GetMaxComboNum()
        {
            var combo = 0;
            foreach (var item in items.Reverse<Item>())
            {
                if (!item.IsLastItem())
                    continue;

                var newCombo = getComboNum(item, 1);
                if (combo < newCombo)
                    combo = newCombo;
            }
            return combo;

        }

        private int getComboNum(Item item, int i)
        {
            if (item.IsFirstItem())
                return i;

            var before = new List<int> { 0, 0, 0 };
            if (item.Before1 != null)
            {
                before[0] = getComboNum(item.Before1, i + 1);
                item.Before1 = null;
            }
            if (item.Before2 != null)
            {
                before[1] = getComboNum(item.Before2, i + 1);
                item.Before2 = null;
            }
            if (item.Before3 != null)
            {
                before[2] = getComboNum(item.Before3, i + 1);
                item.Before3 = null;
            }

            return before.Max();
        }
    }
    public class Item
    {
        public int ItemId { get; set; }
        public int Val { get; set; }

        public Item Before1 { get; set; }
        public Item Before2 { get; set; }
        public Item Before3 { get; set; }

        public Item After1 { get; set; }
        public Item After2 { get; set; }
        public Item After3 { get; set; }

        public Item(int id, int val)
        {
            ItemId = id;
            Val = val;
        }
        public bool IsLastItem()
        {
            return After1 == null
                && After2 == null
                && After3 == null
                ;
        }
        public bool IsFirstItem()
        {
            return Before1 == null
                && Before2 == null
                && Before3 == null
                ;
        }

    }


}
