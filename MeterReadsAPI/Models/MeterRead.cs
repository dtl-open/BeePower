namespace MeterReadsAPI.Models
{
    public class MeterRead
    {
        public string Id { get; set; }

        public string MeterNumber { get; set; }

        public double ReadAt {get; set; }

        public double Consumption { get; set; }
    }
}