using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace WebApi1.Controllers
{
    public class StubController : ApiController
    {
        // GET: api/Stub
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/Stub/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/Stub
        public object Post([FromBody]object value)
        {
            var type = new { Name = string.Empty, Age = 0, };
            var user = Newtonsoft.Json.JsonConvert.DeserializeAnonymousType(
                value.ToString(),
                type
            );

            return new
            {
                Result = HttpStatusCode.OK,
                Status = "Success",
                Name = user.Name,
                Age = user.Age,
            };

        }

        // PUT: api/Stub/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Stub/5
        public void Delete(int id)
        {
        }
    }

    public class User
    {
        public string Name { get; set; }
        public int Age { get; set; }
    }
}
