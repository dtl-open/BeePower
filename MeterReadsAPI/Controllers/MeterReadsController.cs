using System;
using MeterReadsAPI.Data;
using MeterReadsAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace MeterReadsAPI.Controllers
{
    [Route("api/meterReads")]
    public class MeterReadsController : Controller
    {
        private ILogger<MeterReadsController> _logger;
        private readonly IUnitOfWork _unitOfWork;

        public MeterReadsController(ILogger<MeterReadsController> logger, IUnitOfWork unitOfWork) {
            _logger = logger;
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public IActionResult GetMeterReads() {

            _logger.LogInformation("Reading all meter reads.");
            return Ok("Lot's of meter reads .... ecr Jenkins Plugin pushed." );
        }

        [HttpPost]
        public IActionResult AddMeterRead([FromBody]MeterRead meterRead){

            try {

                meterRead.Id = Guid.NewGuid().ToString();
                _logger.LogInformation($"Meter Read record is added. Record id is {meterRead.Id}");

                return Created("api/meterReads/" + meterRead.Id, meterRead);

            } catch (Exception ex) {

                _logger.LogWarning($"Exception occured while recording meter read {meterRead.ToString()}. Problem is {ex.Message}");
                return StatusCode(500, "A problem happened while handeling your request.");
            }


        }

        [HttpPost]
        public IActionResult Post([FromBody] MeterRead meterRead)
        {
            if (meterRead == null || !TryValidateModel(meterRead))
            {
                _logger.LogInformation($"Invalid MeterRead was sent - {meterRead.ToString()}.");
                return BadRequest();
            }

            _unitOfWork.MeterReads.Add(new MeterRead
            {
                Id = meterRead.Id,
                MeterNumber = meterRead.MeterNumber,
                ReadAt = meterRead.ReadAt,
                Consumption = meterRead.Consumption
            });

            var complete = _unitOfWork.Complete();
            
            _logger.LogInformation($"Meter Read record is added. Record id is {meterRead.Id}");

            return Ok(complete);
        }
    }
}
