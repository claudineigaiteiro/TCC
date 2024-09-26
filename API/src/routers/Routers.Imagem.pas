unit Routers.Imagem;

interface

uses
  Controlers.Imagens, Horse, Horse.Jhonson, Horse.CORS;

procedure RoutersImagens;

implementation

procedure RoutersImagens;
begin

  THorse.Post('/imagem', Controlers.Imagens.postImagem);

end;

end.
