using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Runtime.Serialization;
using System.Threading;
namespace WebClient
{
    class Program
    {
        static private HttpClient client;
        static Uri uri = new Uri("http://localhost:50000");
        static void Main(string[] args)
        {
            if (client == null)
                client = new HttpClient();

            /*
            var content = new FormUrlEncodedContent(new Dictionary<string, string>
            {
                { "foo", "111" },
                { "bar", "222" },
                { "baz", "333" }
            });
            */
            var obj = new Item()
            {
                ItemName = "item1",
                Complete = false,
            };
            var content = new StringContent(JsonConvert.SerializeObject(obj));
            var res = call(content);
            System.Diagnostics.Debug.WriteLine("==========================");
            var resObj = JsonConvert.DeserializeObject<Res>(res.Result);
            //var itemObj = JsonConvert.DeserializeObject<Item>(resObj.Content);
            Thread.Sleep(1000);
        }

        static async Task<string> call(HttpContent content)
        {
       
            var res = await client.PostAsync(uri, content);
            return await res.Content.ReadAsStringAsync();
        }
    }
    [DataContract]
    public class Item
    {
        public int Id { get; set; }

        [DataMember(Name = "item_name")]
        public string ItemName { get; set; }

        [DataMember(Name = "complete")]
        public bool Complete { get; set; }
    }

    [DataContract]
    public class Res
    {
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public string QueryStrings { get; set; }
        [DataMember]
        public Methods Method { get; set; }
        [DataMember(Name ="content")]
        public Item Content { get; set; }

        public enum Methods
        {
            GET, POST
        }
    }


}
