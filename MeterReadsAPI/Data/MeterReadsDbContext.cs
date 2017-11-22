using System;
using MeterReadsAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace MeterReadsAPI.Data
{
    public class MeterReadsDbContext : DbContext
    {
        public MeterReadsDbContext(DbContextOptions<MeterReadsDbContext> options) : base(options)
        {
        }

        public DbSet<MeterRead> MeterReads { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
        }
    }
}