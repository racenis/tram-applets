unit TramAssetDatabase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TramAssetMetadata, Tram3DModelAsset, TramAnimationAsset,
  TramAudioAsset, TramAudioSourceAsset, TramNavmeshAsset, TramPathAsset,
  TramSpriteAsset, TramMaterialAsset, TramWorldCellAsset, TramDialogAsset,
  TramEntityDefinitionAsset, TramLanguageAsset, TramQuestAsset,
  Tram3DModelSourceAsset, TramTexturrSourceAsset, TramShaderAsset,
  TramScriptAsset, TramCollisionModelAsset;

type
  TAssetDatabase = class
  public
     constructor Create;
     procedure LoadFromDisk;
     procedure ScanFromDisk;
     procedure SaveToDisk;

     procedure Remove(asset: TAssetMetadata);

     function GetAssets: TAssetMetadataArray;

     function InsertFromDB(assetType: string; name: string; date: Integer): TAssetMetadata;

     protected
        collection3Dmodel: T3DModelCollection;
        collectionMaterial: TMaterialCollection;
        collectionAnimation: TAnimationCollection;
        collectionAudio: TAudioCollection;
        collectionAudioSource: TAudioSourceCollection;
        collectionNavmesh: TNavmeshCollection;
        collectionPath: TPathCollection;
        collectionSprite: TSpriteCollection;
        collectionWorldCell: TWorldCellCollection;
        collectionDialog: TDialogCollection;
        collectionEntityDefinition: TEntityDefinitionCollection;
        collectionLanguage: TLanguageCollection;
        collectionQuest: TQuestCollection;
        collection3DModelSource: T3DModelSourceCollection;
        collectionTextureSource: TTextureSourceCollection;
        collectionShader: TShaderCollection;
        collectionScript: TScriptCollection;
        collectionCollisionModel: TCollisionModelCollection;
  end;

implementation

constructor TAssetDatabase.Create;
begin
  collection3Dmodel := T3DModelCollection.Create;
  collectionMaterial := TMaterialCollection.Create;
  collectionAnimation := TAnimationCollection.Create;
  collectionAudio := TAudioCollection.Create;

  collectionAudioSource := TAudioSourceCollection.Create;
  collectionNavmesh := TNavmeshCollection.Create;
  collectionPath := TPathCollection.Create;
  collectionSprite := TSpriteCollection.Create;
  collectionWorldCell := TWorldCellCollection.Create;
  collectionDialog := TDialogCollection.Create;
  collectionEntityDefinition := TEntityDefinitionCollection.Create;
  collectionLanguage := TLanguageCollection.Create;
  collectionQuest := TQuestCollection.Create;
  collection3DModelSource := T3DModelSourceCollection.Create;
  collectionTextureSource := TTextureSourceCollection.Create;
  collectionShader := TShaderCollection.Create;
  collectionScript := TScriptCollection.Create;
  collectionCollisionModel := TCollisionModelCollection.Create;
end;

procedure TAssetDatabase.LoadFromDisk;
begin
  // TODO: implement
end;

procedure TAssetDatabase.SaveToDisk;
begin
  // TODO: implement
end;

procedure TAssetDatabase.ScanFromDisk;
begin
  collection3Dmodel.ScanFromDisk;
  collectionMaterial.ScanFromDisk;
  collectionAnimation.ScanFromDisk;
  collectionAudio.ScanFromDisk;

  collectionAudioSource.ScanFromDisk;
  collectionNavmesh.ScanFromDisk;
  collectionPath.ScanFromDisk;
  collectionSprite.ScanFromDisk;
  collectionWorldCell.ScanFromDisk;
  collectionDialog.ScanFromDisk;
  collectionEntityDefinition.ScanFromDisk;
  collectionLanguage.ScanFromDisk;
  collectionQuest.ScanFromDisk;
  collection3DModelSource.ScanFromDisk;
  collectionTextureSource.ScanFromDisk;
  collectionShader.ScanFromDisk;
  collectionScript.ScanFromDisk;
  collectionCollisionModel.ScanFromDisk;
end;

procedure TAssetDatabase.Remove(asset: TAssetMetadata);
begin
  collection3Dmodel.Remove(asset);
  collectionMaterial.Remove(asset);
  collectionAnimation.Remove(asset);
  collectionAudio.Remove(asset);

  collectionAudioSource.Remove(asset);
  collectionNavmesh.Remove(asset);
  collectionPath.Remove(asset);
  collectionSprite.Remove(asset);
  collectionWorldCell.Remove(asset);
  collectionDialog.Remove(asset);
  collectionEntityDefinition.Remove(asset);
  collectionLanguage.Remove(asset);
  collectionQuest.Remove(asset);
  collection3DModelSource.Remove(asset);
  collectionTextureSource.Remove(asset);
  collectionShader.Remove(asset);
  collectionScript.Remove(asset);
  collectionCollisionModel.Remove(asset);
end;

function TAssetDatabase.GetAssets: TAssetMetadataArray;
begin
  Result := collection3Dmodel.GetAssets;
  Result := Concat(Result, collectionMaterial.GetAssets);
  Result := Concat(Result, collectionAnimation.GetAssets);
  Result := Concat(Result, collectionAudio.GetAssets);

  Result := Concat(Result, collectionAudioSource.GetAssets);
  Result := Concat(Result, collectionNavmesh.GetAssets);
  Result := Concat(Result, collectionPath.GetAssets);
  Result := Concat(Result, collectionSprite.GetAssets);
  Result := Concat(Result, collectionWorldCell.GetAssets);
  Result := Concat(Result, collectionDialog.GetAssets);
  Result := Concat(Result, collectionEntityDefinition.GetAssets);
  Result := Concat(Result, collectionLanguage.GetAssets);
  Result := Concat(Result, collectionQuest.GetAssets);
  Result := Concat(Result, collection3DModelSource.GetAssets);
  Result := Concat(Result, collectionTextureSource.GetAssets);
  Result := Concat(Result, collectionShader.GetAssets);
  Result := Concat(Result, collectionScript.GetAssets);
  Result := Concat(Result, collectionCollisionModel.GetAssets);
end;

function TAssetDatabase.InsertFromDB(assetType: string; name: string; date: Integer): TAssetMetadata;
begin
  WriteLn(assetType);
  case assetType of
       'STMDL', 'DYMDL', 'MDMDL': Result := collection3Dmodel.InsertFromDB(name, date);
       'MATERIAL': Result := collectionMaterial.InsertFromDB(name, date);
       'ANIM': Result := collectionAnimation.InsertFromDB(name, date);
       'AUDIO': Result := collectionAudio.InsertFromDB(name, date);
       'AUDIOSRC': Result := collectionAudioSource.InsertFromDB(name, date);
       'NAVMESH': Result := collectionNavmesh.InsertFromDB(name, date);
       'PATH': Result := collectionPath.InsertFromDB(name, date);
       'SPRITE': Result := collectionSprite.InsertFromDB(name, date);
       'WORLDCELL': Result := collectionWorldCell.InsertFromDB(name, date);
       'DIALOG': Result := collectionDialog.InsertFromDB(name, date);
       'QUEST': Result := collectionQuest.InsertFromDB(name, date);
       'MDLSRC': Result := collection3DModelSource.InsertFromDB(name, date);
       'TEXSRC': Result := collectionTextureSource.InsertFromDB(name, date);
       'SHADER': Result := collectionShader.InsertFromDB(name, date);
       'SCRIPT': Result := collectionScript.InsertFromDB(name, date);
       'LANG': Result := collectionLanguage.InsertFromDB(name, date);
       'ENTDEF': Result := collectionEntityDefinition.InsertFromDB(name, date);
       'COLLMDL': Result := collectionCollisionModel.InsertFromDB(name, date);
  end;
end;

end.

