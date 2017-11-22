using System;
using MeterReadsAPI.Repositories;

namespace MeterReadsAPI.Data
{
    public interface IUnitOfWork : IDisposable
    {
        IMeterReadsRepository MeterReads { get; }
        int Complete();
    }
}
