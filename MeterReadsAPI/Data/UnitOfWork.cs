using MeterReadsAPI.Repositories;

namespace MeterReadsAPI.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly MeterReadsDbContext _context;

        public UnitOfWork(MeterReadsDbContext context)
        {
            _context = context;
            MeterReads = new MeterReadsRepository(_context);
        }

        public IMeterReadsRepository MeterReads { get; }

        public int Complete()
        {
            return _context.SaveChanges();
        }

        public void Dispose()
        {
            _context.Dispose();
        }

    }
}