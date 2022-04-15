import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0
import "../MainSubComponents"


Popup {
    id: licensePopup
    x: parent.width/2 - 500
    y: parent.height/2 - 400
    width: 1000
    height: 800
    modal: true
    focus: true

    property var appInfo;

    Component.onCompleted: {
        appInfo = GeneralParamsModel.getAppInfo()
    }

   


//   Rectangle{
//      width:parent.width
//         height:parent.height
//       color:"red"
//        Flickable {
//         contentHeight: parent.height
//         contentWidth:800
//         ScrollBar.vertical: ScrollBar { }
// //  clip: true
//             flickableDirection: Flickable.VerticalFlick

//             // ScrollBar.vertical: ScrollBar {
//             //     active: flickText.moving || !flickText.moving
//             // }
        
  
 
    ListView{
         width:parent.width
        height:parent.height-50
        model:1
        // anchors.padding:50
        ScrollBar.vertical: ScrollBar { }
         clip:true
        delegate:Row{
             width:parent.width-50
             
        Text{
        width:parent.width

        id: header2
       
        // width:parent.width
        // height:parent.height
        // clip: true
         wrapMode: "WordWrap"
        text: qsTr(`<p>End User License Agreement (&ldquo;EULA&rdquo;)</p> <p>The terms and conditions of this End User License Agreement (&ldquo;EULA&rdquo;) apply to licensee&rsquo;s (&ldquo;You&rdquo; or &ldquo;Your&rdquo;) use, access, copy and download, and the license and delivery of Software by Grafieks Analytics Ltd (&ldquo;Company,&rdquo; &ldquo;we,&rdquo; &ldquo;us&rdquo; or &ldquo;our&rdquo;).</p> <p>PLEASE READ THIS AGREEMENT CAREFULLY. IT CONTAINS IMPORTANT TERMS THAT AFFECT YOU AND YOUR USE OF THE SOFTWARE. BY INSTALLING, COPYING OR USING THE SOFTWARE, YOU AGREE TO BE BOUND BY THE TERMS OF THIS AGREEMENT. IF YOU DO NOT AGREE TO THESE TERMS, DO NOT INSTALL, COPY, OR USE THE SOFTWARE. IF YOU ARE ACCESSING OR USING THE SOFTWARE ON BEHALF OF ANY ENTITY OR OTHERWISE IN PERFORMANCE OF SERVICES FOR ANY ENTITY, YOU REPRESENT AND WARRANT THAT YOU ARE AUTHORIZED TO ACCEPT THIS AGREEMENT ON SUCH ENTITY'S BEHALF, THAT ACCEPTANCE OF THIS AGREEMENT AND USE OF THIS SOFTWARE WILL NOT VIOLATE ANY AGREEMENT YOU HAVE WITH SUCH ENTITY, AND THAT SUCH ENTITY AGREES TO INDEMNIFY YOU AND COMPANY FOR VIOLATIONS OF THIS AGREEMENT.</p> <p>&nbsp;</p> <ol> <p>1. Software License</p> </ol> <p>Subject to the terms and conditions of this Agreement and during the term of this Agreement, the Company hereby grants you a non-exclusive, non-sublicensable, non-transferable license to [install and use] [stream, access, download and use] one copy of the Software in object code form only on a single [personal computing device] [network server] solely to use the services made available by Company (the &ldquo;<strong><em>Company Services</em></strong>&rdquo;) for your own personal or internal business use (the &ldquo;<strong><em>Permitted Purpose</em></strong>&rdquo;). Any Software that updates, supplements or replaces the original Software is governed by this Agreement unless separate license terms accompany such update, supplement or replacement, in which case such separate terms will govern in the event of a conflict with this Agreement or as otherwise provided in such separate terms.</p> <p>&nbsp;</p> <ol start="2"> <p>2. License Limitations</p> </ol> <p>Section 1 states the entirety of your rights with respect to the Software, and we reserve all rights not expressly granted to you in this Agreement. Without limiting the foregoing, you will not do, or authorize or permit any third party to do, any of the following: (a) distribute, sub-license, sell, assign, or otherwise transfer or make available the Software; (b) use the Software for any purpose other than the Permitted Purpose; (c) reverse engineer, decompile, disassemble or otherwise attempt to discover or re-create the source code for the Software; (d) modify, adapt, alter, improve or create any derivative works of the Software; (e) connect the Software with any other online services or use the Software in conjunction with other software or services not provided by or permitted by Company [in connection with the Company Services]; (f) remove, circumvent or create or use any workaround to any copy protection or security feature in or relating to the Software; or (g) remove, alter or obscure any copyright, trademark or other proprietary rights notice on or in the Software.</p> <p>&nbsp;</p> <ol start="3"> <p>3. Ownership and Confidentiality</p> </ol> <p>The Software is licensed, not sold, to you. We or our licensors own all right, title and interest in and to the Software, including all copyright, patent and other intellectual property or other proprietary rights in the Software. No title to or ownership of the Software or any associated intellectual property or proprietary rights are transferred to you by this Agreement. You also acknowledge that when you download, install or use the Software, we have the right to automatically collect information on your use of the Software. We may also require that you provide information regarding yourself in order to download, install or use the Software or certain features. All information collected from you in connection with the Software may be used by us in compliance with our Privacy Policy. By your using, installing, downloading or providing information, you consent to the Privacy Policy and our use of your information in compliance thereof. [YOU ARE EXPRESSLY PROHIBITED FROM DISCLOSING THE SOFTWARE TO ANY PERSON OR ENTITY OR PERMITTING ANY PERSON OR ENTITY ACCESS TO OR USE OF THE SOFTWARE OTHER THAN IN ACCORDANCE WITH THIS AGREEMENT.</p> <p>&nbsp;</p> <ol start="4"> <p>4. Disclaimers</p> </ol> <p>THE SOFTWARE IS PROVIDED TO YOU ON AN &ldquo;AS IS&rdquo; BASIS AND WITH ALL FAULTS AND DEFECTS WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. COMPANY AND ITS LICENSORS DISCLAIM ALL OTHER WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. COMPANY DOES NOT REPRESENT OR WARRANT THAT THE SOFTWARE IS FREE OF BUGS, ERRORS, VIRUSES OR OTHER DEFECTS OR THAT THE SOFTWARE WILL TRANSMIT DATA IN A SECURE MANNER. COMPANY AND ITS LICENSORS SHALL HAVE NO LIABILITY OF ANY KIND FOR THE USE OF OR INABILITY TO USE THE SOFTWARE. COMPANY AND ITS LICENSORS PROVIDES ANY WARRANTY OR REPRESENTATIONS OF ANY KIND THAT THE SOFTWARE WILL OPERATE WITHOUT INTERRUPTION, MEET ANY PERFORMANCE OR RELIABILITY STANDARDS, ACHIEVE ANY KIND OF INTENDED PURPOSE, BE COMPATIBLE WITH ANY OTHER SOFTWARE OR SYSTEM, OR HAVE ERRORS THAT CAN BE CORRECTED.</p> <p>Some jurisdictions do not allow the exclusion of implied warranties or limitations on how long an implied warranty may last. To the extent that those laws apply to this Agreement, the exclusions and limitations set forth above may not apply.</p> <p>&nbsp;</p> <ol start="5"> <p>5. Indemnification</p> </ol> <p>You will defend, indemnify and hold harmless Company and its affiliates, independent contractors, service providers, suppliers, partners, resellers, distributors and consultants, and their respective directors, officers, employees and agents (collectively, the &ldquo;<strong><em>Company Parties</em></strong>&rdquo;) from and against any third party claims, suits or actions and any resulting damages, costs, liabilities and expenses (including, but not limited to, reasonable attorneys' fees) arising out of or related to: (a) your use of, or inability to use, the Software; or (b) your violation of any terms of this Agreement.</p> <p>&nbsp;</p> <ol start="6"> <p>6. Limitation of Liability</p> </ol> <p>IN NO EVENT SHALL ANY OF THE COMPANY PARTIES BE LIABLE FOR ANY DIRECT, SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY OTHER DAMAGES OF ANY KIND, INCLUDING BUT NOT LIMITED TO LOSS OF USE, LOSS OF PROFITS OR LOSS OF DATA, WHETHER IN AN ACTION IN CONTRACT, TORT (INCLUDING BUT NOT LIMITED TO NEGLIGENCE) OR OTHERWISE, ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF A COMPANY PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. IN NO EVENT SHALL THE AGGREGATE LIABILITY OF THE COMPANY PARTIES, WHETHER IN CONTRACT, WARRANTY, TORT (INCLUDING NEGLIGENCE, WHETHER ACTIVE, PASSIVE OR IMPUTED), PRODUCT LIABILITY, STRICT LIABILITY OR OTHER THEORY, ARISING OUT OF OR RELATING TO THIS AGREEMENT OR THE SOFTWARE EXCEED THE COMPENSATION YOU HAVE PAID, IF ANY, TO COMPANY FOR THE SOFTWARE.</p> <p>Some jurisdictions do not allow the exclusion or limitation of certain damages. To the extent that those laws apply to this Agreement, the exclusions and limitations set forth above may not apply.</p> <p>&nbsp;</p> <ol start="7"> <p>7. Termination</p> </ol> <p>Company may terminate this Agreement at any time, with or without cause, immediately upon notice to you. [Company may also discontinue the Company Services with which the Software is used, in which case this Agreement will terminate automatically without notice to you]. You may terminate this Agreement [by cancelling your Company Services account opened in connection with your use of the Software and] deleting all copies of the Software in your possession or control. In the event of the termination of this Agreement for any reason: (a) the license granted to you in this Agreement will terminate; (b) you must immediately cease all use of the Software and destroy or erase all copies of the Software in your possession or control; and (c) Sections 3 (Ownership), 4 (Disclaimers), 5 (Indemnification), 6 (Limitation of Liability), 7 (Termination), 8 (Governing Law; Jurisdiction) and 9 (General) will survive any such termination. [Further, in the event the agreement governing your use of the Company Services with which the Software is used is terminated for any reason, this Agreement will terminate automatically without notice to you].</p> <p>&nbsp;</p> <ol start="8"> <p>8. Evaluation and Feedback</p> </ol> <p>You will at your own risk and expense use reasonable efforts to provide Company with reasonable information and feedback (including, without limitation, questions, comments, suggestions, or the like) regarding the performance, features, functionality and your overall experience using the Software (&ldquo;Feedback&rdquo;) and will make yourself available to Company on a reasonable basis for this purpose. You will not provide any such Feedback to any third party without Company&rsquo;s prior written consent in each instance. You hereby grant to Company an exclusive, royalty-free, irrevocable, perpetual worldwide right and license to reproduce, use, disclose, exhibit, display, transform, create derivative works and distribute any such Feedback without limitation. Further, we will be free to use any ideas, concepts, know-how or techniques contained in such Feedback for any purpose whatsoever, including, without limitation, developing, making, marketing, distributing and selling products and services incorporating such Feedback. We will have no obligation to consider, use, return or preserve any Feedback you provide to us. Any Feedback you provide to us may or may not be treated confidentially by us, and we will have no obligation or liability to you for the use or disclosure of any Feedback. You should not expect any compensation of any kind from us with respect to your Feedback.</p> <p>&nbsp;</p> <ol start="9"> <p>9. Governing Law; Jurisdiction</p> </ol> <p>This agreement and any dispute or claim arising out of or in connection with it or its subject matter or formation (including non-contractual disputes or claims) shall be governed by and construed in accordance with the laws of Ireland. Each party irrevocably agrees that the courts of Ireland shall have exclusive jurisdiction to settle any dispute or claim arising out of or in connection with this agreement or its subject matter or formation (including non-contractual disputes or claims).</p> <p>&nbsp;</p> <ol start="10"> <p>10. General</p> </ol> <p>(a) Severability. If any provision of this Agreement is held by a court of competent jurisdiction to be invalid, illegal, or unenforceable, the remainder of this Agreement will remain in full force and effect, and the remaining provisions will be amended to achieve as closely as possible the effect of the original term and all other provisions of this Agreement will continue in full force.</p> <p>&nbsp;</p> <p>(d) Assignment. You may not assign or otherwise transfer this Agreement, or assign, sublicense or otherwise transfer any of your rights under this Agreement without the prior written consent of Company, and any attempted assignment without such consent will be void.</p> <p>&nbsp;</p> <p>(e) Attorney's Fees. In any action or proceeding to enforce rights under this Agreement, the prevailing party will be entitled to recover costs and reasonable attorney's fees.</p> <p>&nbsp;</p> <p>(f) Entire Agreement. This Agreement, our Privacy Policy sets forth our entire agreement with respect to the Software and supersedes all prior and contemporaneous understandings and agreements with respect to the Software whether written or oral.</p> <p>&nbsp;</p> <p>&nbsp;</p>`)
        // text:"jhdga jdkbnsa hjfebsd jdsnb jkdsfna jdsba jdsab kjldsn jhbeafs jbdsfa jbldfse jdsfb jbdsa jlkbnasdf jkndsa jbdsa jhksadb jhasdb jhbasdff jhbdsfa jkbdasf jhbdfsa jhdkbsefa jhkebsaf jhsdba lkjsdabn fhjdsab olufjadsneb jdhab jhfdgsvsb adsjfhb kjhsdafbjhkadsbf jhbdfsa jhbfsd jhbdsa hjbf "
        font.pointSize: 8
        font.family: Constants.fontDefault
        anchors.top: header1.bottom
        // anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin:17
        textFormat:Qt.RichText

         }  }
        
    }

    CustomButton{
            id: closeBtn
            
            height:40
            width:120
            contentItem:Text {
                text: "Close"
                color:"white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            

            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.bottom:parent.bottom


            onClicked: {
                licensePopup.close()
            }
            background:Rectangle{
                height:parent.height
                width:parent.width
                color:Constants.buttonHoverColor
            }
        }
    //  }
    //    }
  



}
