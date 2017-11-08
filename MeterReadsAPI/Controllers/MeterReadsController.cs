using System;
using System.Collections.Generic;
using MeterReadsAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace MeterReadsAPI.Controllers
{
    [Route("api/meterReads")]
    public class MeterReadsController : Controller
    {
        private IList<MeterRead> meterReads = new List<MeterRead>();

        [HttpGet]
        public IActionResult GetMeterReads() {
            
            return Ok("Lot's of meter reads .... " + this.meterReads.Count);
        }

        [HttpPost]
        public IActionResult AddMeterRead([FromBody]MeterRead meterRead){

            meterRead.Id = Guid.NewGuid().ToString();
            this.meterReads.Add(meterRead);

            return Created("api/meterReads/" + meterRead.Id, meterRead);
        }
    }
}
