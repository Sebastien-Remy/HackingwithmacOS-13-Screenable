//
//  RenderView.swift
//  Screenable
//
//  Created by Sebastien REMY on 02/11/2022.
//

import SwiftUI

struct RenderView: View {
    let document: ScreenableDocument // No @Binding cause it's read only ScreenableDocument
    
    var body: some View {
        Canvas { context, size in
            // set up
            let fullSizeRect = CGRect(origin: .zero, size: size)
            let fullSizePath = Path(fullSizeRect)
            let phoneSize = CGSize(width: 300, height: 607)
            let imageInsets = CGSize(width: 16, height: 14)
            
            // draw background image
            context.fill(fullSizePath, with: .color(.white))
            if document.backgroundImage.isEmpty == false {
                context.draw(Image(document.backgroundImage), in: fullSizeRect)
            }
            
            // add gradient
            context.fill(fullSizePath, with: .linearGradient(
                Gradient(
                colors: [document.backgroundColorTop, document.backgroundColorBottom]),
                startPoint: .zero,
                endPoint: CGPoint(x: 0, y: size.height)))
            
            // draw caption
            var verticalOffset = 0.0 // How much we need to down phone image and screenshot based on what the user wrote for their caption
            let horizontalOffSet = (size.width - phoneSize.width) / 2
            if document.caption.isEmpty {
                verticalOffset = (size.height - phoneSize.height) / 2
            } else {
                if let resolvedCaption = context.resolveSymbol(id: "Text") {
                    // center the text
                    let textXPosition = (size.width - resolvedCaption.size.width) / 2
                    
                    // draw it 20 points from the top
                    context.draw(resolvedCaption, in: CGRect(origin:
                                                                CGPoint(x: textXPosition,
                                                                        y: 20),
                                                             size: resolvedCaption.size)
                    )
                    
                    // use text heigt + 20 before the text (top) + 20 after the text
                    verticalOffset = resolvedCaption.size.height + 40
                }
            }
            
            // draw user image
            if let screenshot = context.resolveSymbol(id: "Image") {
                let drawPosition = CGPoint(x: horizontalOffSet + imageInsets.width,
                                           y: verticalOffset + imageInsets.height)
                let drawSize = CGSize(width: phoneSize.width - imageInsets.width * 2,
                                      height: phoneSize.height - imageInsets.height * 2)
                context.draw(screenshot, in: CGRect(origin: drawPosition,
                                                    size: drawSize))
            }
            
            // draw phone
            context.draw(Image("iPhone"), in: CGRect(origin:
                                                    CGPoint(x: horizontalOffSet,
                                                            y: verticalOffset),
                                                   size: phoneSize))
            
        } symbols: {
            // add custom SwiftUI views
            
            // caption
            Text(document.caption)
                .font(.custom(document.font, size: Double(document.fontSize)))
                .foregroundColor(document.captionColor)
                .multilineTextAlignment(.center)
                .tag("Text") // use tag to find this view in the rendering closure
            
            // user image
            if let userImage = document.userImage, let nsImage = NSImage(data: userImage) {
                Image(nsImage: nsImage)
                    .tag("Image")
            } else {
                Color.gray
                    .tag("Image")
            }
        }
        .frame(width: 414, height: 736)
    }
}

struct RenderView_Previews: PreviewProvider {
    static var previews: some View {
        var document = ScreenableDocument()
        document.caption = "Document caption"
        return RenderView(document: document)
    }
}
