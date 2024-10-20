module FamilyEventsBackend.App

open System
open System.IO
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Cors.Infrastructure
open Microsoft.AspNetCore.Hosting
open Microsoft.Extensions.Hosting
open Microsoft.Extensions.Logging
open Microsoft.Extensions.DependencyInjection
open Giraffe
open FamilyEventsBackend.Data


// ---------------------------------
// Models
// ---------------------------------

type Message = { Text: string }

// ---------------------------------
// Views
// ---------------------------------

module Views =
    open Giraffe.ViewEngine

    let indexPage: XmlNode =
        html
            []
            [ head
                  []
                  [ meta [ _charset "UTF-8" ]
                    meta [ _name "viewport"; _content "width=device-width, initial-scale=1.0" ]
                    title [] [ encodedText "Family Events" ] ]
              body [] [ div [ _id "elm" ] []; script [ _type "module"; _src "/src/Main.elm" ] [] ] ]

// ---------------------------------
// Web app
// ---------------------------------

let getEventsHandler: HttpHandler = json Data.persons

let webApp =
    choose
        [ GET
          >=> choose
                  [ route "/" >=> htmlFile "WebRoot/index.html"
                    route "/events" >=> getEventsHandler ]
          setStatusCode 404 >=> text "Not Found" ]

// ---------------------------------
// Error handler
// ---------------------------------

let errorHandler (ex: Exception) (logger: ILogger) =
    logger.LogError(ex, "An unhandled exception has occurred while executing the request.")
    clearResponse >=> setStatusCode 500 >=> text ex.Message

// ---------------------------------
// Config and Main
// ---------------------------------

let configureCors (builder: CorsPolicyBuilder) =
    let allowedOrigins =
        match System.Environment.GetEnvironmentVariable("ALLOWED_ORIGINS") with
        | null -> "http://localhost:5173,http://localhost:8000,http://localhost:5000,https://localhost:5001"
        | value -> value

    builder.WithOrigins(allowedOrigins.Split(',')).AllowAnyMethod().AllowAnyHeader()
    |> ignore

let configureApp (app: IApplicationBuilder) =
    let env = app.ApplicationServices.GetService<IWebHostEnvironment>()

    (match env.IsDevelopment() with
     | true -> app.UseDeveloperExceptionPage()
     | false -> app.UseGiraffeErrorHandler(errorHandler).UseHttpsRedirection())
        .UseCors(configureCors)
        .UseStaticFiles()
        .UseGiraffe(webApp)

let configureServices (services: IServiceCollection) =
    services.AddCors() |> ignore
    services.AddGiraffe() |> ignore

let configureLogging (builder: ILoggingBuilder) =
    builder.AddConsole().AddDebug() |> ignore

[<EntryPoint>]
let main args =
    let contentRoot = Directory.GetCurrentDirectory()
    let webRoot = Path.Combine(contentRoot, "WebRoot")

    Host
        .CreateDefaultBuilder(args)
        .ConfigureWebHostDefaults(fun webHostBuilder ->
            webHostBuilder
                .UseContentRoot(contentRoot)
                .UseWebRoot(webRoot)
                .Configure(Action<IApplicationBuilder> configureApp)
                .ConfigureServices(configureServices)
                .ConfigureLogging(configureLogging)
            |> ignore)
        .Build()
        .Run()

    0
