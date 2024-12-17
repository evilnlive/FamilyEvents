using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;

namespace FamilyEventsBackend.App
{
    public class Program
    {
        // Error Handler
        public static async Task ErrorHandler(HttpContext context)
        {
            var logger = context.RequestServices.GetService<ILogger<Program>>();
            var exception = context.Features.Get<Microsoft.AspNetCore.Diagnostics.IExceptionHandlerFeature>()?.Error;

            if (exception != null)
            {
                logger.LogError(exception, "An unhandled exception occurred.");
                context.Response.StatusCode = 500;
                await context.Response.WriteAsync(exception.Message);
            }
        }

        // Handlers
        public static async Task GetWeekHandler(HttpContext context)
        {
            await context.Response.WriteAsJsonAsync(Data.Weeks[0]);
        }

        public static async Task GetWeeksHandler(HttpContext context)
        {
            await context.Response.WriteAsJsonAsync(Data.Weeks);
        }

        // Configure Middleware
        public static void ConfigureApp(IApplicationBuilder app)
        {
            var env = app.ApplicationServices.GetService<IWebHostEnvironment>();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler(errorApp => errorApp.Run(ErrorHandler));
                app.UseHttpsRedirection();
            }

            app.UseCors(builder =>
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader());

            app.UseStaticFiles();

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapGet("/", async context =>
                {
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "WebRoot", "index.html");
                    await context.Response.SendFileAsync(filePath);
                });

                endpoints.MapGet("/week", GetWeekHandler);
                endpoints.MapGet("/weeks", GetWeeksHandler);

                endpoints.MapFallback(async context =>
                {
                    context.Response.StatusCode = 404;
                    await context.Response.WriteAsync("Not Found");
                });
            });
        }

        // Configure Services
        public static void ConfigureServices(IServiceCollection services)
        {
            services.AddCors();
            services.AddRouting();
        }

        public static void ConfigureLogging(ILoggingBuilder builder)
        {
            builder.AddConsole();
            builder.AddDebug();
        }

        // Main Entry Point
        public static int Main(string[] args)
        {
            var contentRoot = Directory.GetCurrentDirectory();
            var webRoot = Path.Combine(contentRoot, "WebRoot");

            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseContentRoot(contentRoot)
                              .UseWebRoot(webRoot)
                              .Configure(ConfigureApp)
                              .ConfigureServices(ConfigureServices)
                              .ConfigureLogging(ConfigureLogging);
                })
                .Build()
                .Run();

            return 0;
        }
    }
}