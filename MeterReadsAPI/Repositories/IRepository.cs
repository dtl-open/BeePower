using System;
using System.Collections.Generic;

namespace MeterReadsAPI.Repositories
{
    public interface IRepository<TEntity> where TEntity : class
    {
        TEntity Get(int id);
        IEnumerable<TEntity> GetAll();

        void Add(TEntity entity);

        void Remove(TEntity entity);
    }
}