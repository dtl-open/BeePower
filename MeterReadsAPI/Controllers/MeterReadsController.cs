using System;
using MeterReadsAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace MeterReadsAPI.Controllers
{
    [Route("api/meterReads")]
    public class MeterReadsController : Controller
    {
        private ILogger<MeterReadsController> logger;

        public MeterReadsController(ILogger<MeterReadsController> logger) {
            this.logger = logger;
        }

        [HttpGet]
        public IActionResult GetMeterReads() {

            logger.LogInformation("Reading all meter reads.");
            return Ok("Lot's of meter reads .... ecr Jenkins Plugin pushed." );
        }

        [HttpPost]
        public IActionResult AddMeterRead([FromBody]MeterRead meterRead){

            try {

                meterRead.Id = Guid.NewGuid().ToString();
                logger.LogInformation($"Meter Read record is added. Record id is {meterRead.Id}");

                return Created("api/meterReads/" + meterRead.Id, meterRead);

            } catch (Exception ex) {

                logger.LogWarning($"Exception occured while recording meter read {meterRead.ToString()}. Problem is {ex.Message}");
                return StatusCode(500, "A problem happened while handeling your request.");
            }


        }
    }
}
