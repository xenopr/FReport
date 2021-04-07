object fDB: TfDB
  Left = 420
  Top = 271
  Width = 609
  Height = 331
  Caption = #1057#1087#1080#1089#1086#1082' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081' '#1089' '#1073#1072#1079#1072#1084#1080' '#1076#1072#1085#1085#1099#1093
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object eDatabases: TCheckListBox
    Left = 0
    Top = 0
    Width = 221
    Height = 286
    OnClickCheck = eDatabasesClickCheck
    Align = alClient
    ItemHeight = 16
    TabOrder = 0
    OnClick = eDatabasesClick
  end
  object Panel1: TPanel
    Left = 221
    Top = 0
    Width = 370
    Height = 286
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      370
      286)
    object Label1: TLabel
      Left = 10
      Top = 92
      Width = 102
      Height = 16
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 10
      Top = 181
      Width = 98
      Height = 16
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    end
    object Label3: TLabel
      Left = 10
      Top = 211
      Width = 52
      Height = 16
      Caption = #1055#1072#1088#1086#1083#1100':'
    end
    object Label4: TLabel
      Left = 10
      Top = 151
      Width = 90
      Height = 16
      Caption = #1057#1077#1088#1074#1077#1088', '#1073#1072#1079#1072':'
    end
    object Label5: TLabel
      Left = 10
      Top = 124
      Width = 85
      Height = 16
      Caption = #1058#1080#1087' '#1076#1086#1089#1090#1091#1087#1072':'
    end
    object bAdd: TSpeedButton
      Left = 12
      Top = 45
      Width = 28
      Height = 27
      Cursor = crHandPoint
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1089#1087#1080#1089#1086#1082
      Caption = '+'
      ParentShowHint = False
      ShowHint = True
      OnClick = bAddClick
    end
    object bDel: TSpeedButton
      Left = 41
      Top = 45
      Width = 29
      Height = 27
      Cursor = crHandPoint
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072
      Caption = '-'
      ParentShowHint = False
      ShowHint = True
      OnClick = bDelClick
    end
    object bConnect: TSpeedButton
      Left = 73
      Top = 45
      Width = 104
      Height = 27
      Cursor = crHandPoint
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '#1080' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
      ParentShowHint = False
      ShowHint = True
      OnClick = bConnectClick
    end
    object sbConn: TSpeedButton
      Left = 339
      Top = 148
      Width = 23
      Height = 24
      Anchors = [akTop, akRight]
      Caption = '...'
      OnClick = sbConnClick
    end
    object bClose: TBitBtn
      Left = 262
      Top = 239
      Width = 92
      Height = 38
      Cursor = crHandPoint
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
      NumGlyphs = 2
    end
    object eName: TEdit
      Left = 117
      Top = 88
      Width = 245
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object eUser: TEdit
      Left = 117
      Top = 177
      Width = 245
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object ePass: TEdit
      Left = 117
      Top = 206
      Width = 245
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 3
    end
    object eServer: TEdit
      Left = 117
      Top = 147
      Width = 224
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
    object eType: TComboBox
      Left = 117
      Top = 118
      Width = 245
      Height = 24
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 5
      Items.Strings = (
        'BDE'
        'Interbase'
        'Oracle OCI'
        'ADO')
    end
    object bLoad: TBitBtn
      Left = 97
      Top = 6
      Width = 80
      Height = 31
      Cursor = crHandPoint
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = bLoadClick
    end
    object bSave: TBitBtn
      Left = 12
      Top = 6
      Width = 82
      Height = 31
      Cursor = crHandPoint
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = bSaveClick
    end
    object cbFile: TCheckBox
      Left = 188
      Top = 11
      Width = 110
      Height = 21
      Cursor = crHandPoint
      Hint = 
        #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1080' '#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081' '#1074' '#1092#1072#1081#1083', '#13#10#1080#1085#1072#1095#1077' '#1074' '#1088#1077#1077#1089#1090#1088 +
        #1077' windows.'
      Caption = #1074'/'#1080#1079' '#1088#1077#1077#1089#1090#1088#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = cbFileClick
    end
    object cbLoadDBs: TCheckBox
      Left = 189
      Top = 46
      Width = 169
      Height = 21
      Cursor = crHandPoint
      Hint = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' FReport'
      Caption = #1040#1074#1090#1086#1079#1072#1075#1088#1091#1079#1082#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
  end
  object fsDB: TFormStorage
    Active = False
    IniFileName = 'Software\AndyPro\FReport\Databases'
    IniSection = '0'
    Options = []
    UseRegistry = True
    StoredValues = <>
    Left = 56
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = #1092#1072#1081#1083#1099' '#1089#1086' '#1089#1087#1080#1089#1082#1086#1084' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081' (*.cfg)|*.cfg'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 32
    Top = 96
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'cfg'
    Filter = #1092#1072#1081#1083#1099' '#1089#1086' '#1089#1087#1080#1089#1082#1086#1084' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081' (*.cfg)|*.cfg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofCreatePrompt, ofEnableSizing]
    Left = 64
    Top = 96
  end
end
