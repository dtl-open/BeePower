using MeterReadsAPI.Data;
using MeterReadsAPI.Models;

namespace MeterReadsAPI.Repositories
{
    public class MeterReadsRepository : Repository<MeterRead>, IMeterReadsRepository
    {
        public MeterReadsRepository(MeterReadsDbContext context) : base(context)
        {
        }

        public MeterReadsDbContext MeterReadsDbContext
        {
            get { return Context as MeterReadsDbContext; }
        }
    }
}