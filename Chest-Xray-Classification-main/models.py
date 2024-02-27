import timm
from timm import create_model


def model_chest_xray(model_name ,init_weight, num_class, in_chans):
    """create a pre-built model using the timm module

    Args:
        model (str): model name 
        init_weight (bool): initialiaze the model with pre-training weights
        num_class (init): number of classes
        in_chans (init): number of channels for input data

    Returns:
        torch.model: returns the torch model
    """
    model = None
    print("Creating model...")
    model = create_model(model_name=model_name,
                         pretrained=init_weight,
                         num_classes=num_class,
                         in_chans=in_chans)
    return model

def build_model(args):
    model = None    
    pretrained = True if args.init=="ImageNet" else False
    print(f"Creating model {args.model_name} with {args.init} weights.....")
    if args.model_name == "resnet18":
        model = create_model(model_name=args.model_name,
                            pretrained=pretrained,
                            num_classes=args.num_classes,
                            in_chans=args.in_chans)
    
    elif args.model_name == "resnet50":
        model = create_model(model_name=args.model_name,
                            pretrained=pretrained,
                            num_classes=args.num_classes,
                            in_chans=args.in_chans)
        
    elif args.model_name == "swin_tiny":
        model = create_model(model_name="swin_tiny_patch4_window7_224",
                            pretrained=pretrained,
                            num_classes=args.num_classes,
                            in_chans=args.in_chans)
        
    elif args.model_name == "swin_base":
        model = create_model(model_name="swin_base_patch4_window7_224",
                            pretrained=pretrained,
                            num_classes=args.num_classes,
                            in_chans=args.in_chans)
        
    else:
        print(f"Not implemented for {args.model_name} model.")
        raise Exception("Please provide correct model name to build!")
    
    return model