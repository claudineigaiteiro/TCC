program API;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Winapi.Windows,
  System.JSON,
  Routers.Aneometro in 'src\routers\Routers.Aneometro.pas',
  Register in 'src\Register.pas',
  Controlers.Aneometro in 'src\Controlers\Controlers.Aneometro.pas',
  services.aneometro in 'src\services\services.aneometro.pas';

begin
  //FrmVisor.ShowModal;
  Registers;

  // THorse.Post('/novo',
  // procedure(Req: THorseRequest)
  // var
  // LJson: TJSONObject;
  // LText: String;
  // begin
  // LJson := TJSONObject.Create;
  // Try
  // LText := Req.Body;
  // //LJson := StrTo
  // Finally
  // LJson.Free;
  // End;
  //
  // end);

  THorse.Get('/fune',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LJson: TJSONObject;
      LText: String;
    begin
      LJson := TJSONObject.Create;
      Try
        LJson := Req.Body<TJSONObject>;
        LText := Req.Body;
        Res.Send('pong');
      Finally
        LJson.Free;
      End;

    end);

  // THorse.Listen(9000);

end.
